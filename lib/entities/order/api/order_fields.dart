const orderFields = """
    id code totalQuantity subTotalWithTax shippingWithTax totalWithTax currencyCode
    lines { id quantity linePriceWithTax discountedUnitPriceWithTax
      productVariant { id name product { slug featuredAsset { preview } } }
    }
  """;
