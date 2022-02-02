import { PrintSize, PrintSizeVariant } from '../graphql/globalTypes';

export function printSizeVariantToPrintSize(variant: PrintSizeVariant): PrintSize {
  switch (variant) {
    case PrintSizeVariant.m:
      return PrintSize.m;
    case PrintSizeVariant.s:
      return PrintSize.s;
    case PrintSizeVariant.xl:
      return PrintSize.xl;
    case PrintSizeVariant.xlCondensed:
      return PrintSize.xl;
  }
}
