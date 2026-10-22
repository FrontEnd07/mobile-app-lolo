import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

import 'package:ecommerce_new/shared/config/env.dart';

/// Inject token storage and locale from app; shared never imports higher layers.
class ShopApi {
  ShopApi({
    this.language = 'ru',
    this.currency = 'TJS',
    this.channelToken,
    this.isAuthenticated = false,
    this.readToken,
    this.httpClient,
    this.createHttpClient = http.Client.new,
  });
  final String language;
  final String currency;
  final String? channelToken;
  final bool isAuthenticated;
  final Future<String?> Function()? readToken;
  final http.Client? httpClient;
  final http.Client Function() createHttpClient;
  String? capturedToken;

  Future<Json> execute(
    String document,
    Json variables,
    bool mutation, {
    bool authenticated = true,
    String? channelToken,
  }) async {
    capturedToken = null;
    final token = authenticated ? await readToken?.call() : null;
    if (authenticated && (token == null || token.isEmpty)) {
      throw const ApiException('LOGIN_REQUIRED');
    }
    final transport = httpClient ?? createHttpClient();
    final client = GraphQLClient(
      link: HttpLink(
        Uri.parse(Env.vendureEndpoint)
            .replace(
              queryParameters: {
                ...Uri.parse(Env.vendureEndpoint).queryParameters,
                'languageCode': language,
                'currencyCode': currency,
              },
            )
            .toString(),
        httpClient: _CaptureTokenClient(
          transport,
          (token) => capturedToken = token,
        ),
        defaultHeaders: {
          'vendure-token':
              channelToken ?? this.channelToken ?? Env.channelToken,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
      cache: GraphQLCache(),
    );
    try {
      final request = mutation
          ? client.mutate(
              MutationOptions(
                document: gql(document),
                variables: variables,
                fetchPolicy: FetchPolicy.noCache,
              ),
            )
          : client.query(
              QueryOptions(
                document: gql(document),
                variables: variables,
                fetchPolicy: FetchPolicy.noCache,
              ),
            );
      final result = await request.timeout(
        const Duration(seconds: Env.requestTimeoutSeconds),
      );
      if (result.hasException) {
        final error = result.exception?.graphqlErrors.firstOrNull;
        final code = error?.extensions?['code'] as String? ?? 'NETWORK';
        throw ApiException(
          code == 'FORBIDDEN' ? 'ACCESS_DENIED' : code,
          error?.message,
        );
      }
      if (result.data == null) throw const ApiException('EMPTY_RESPONSE');
      return result.data!;
    } finally {
      // A caller owns an injected client; normal requests own their transport.
      if (httpClient == null) transport.close();
    }
  }
}

class _CaptureTokenClient extends http.BaseClient {
  _CaptureTokenClient(this.inner, this.onToken);
  final http.Client inner;
  final void Function(String) onToken;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await inner.send(request);
    final token = response.headers['vendure-auth-token'];
    if (token != null && token.isNotEmpty) onToken(token);
    return response;
  }
}

final shopApiProvider = Provider<ShopApi>((ref) => ShopApi());
