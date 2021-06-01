export const THREE_D_COVER_IMAGE_WIDTHS = [250, 400, 550, 700, 850, 1000, 1120] as const;

export type ThreeDCoverImageWidth = typeof THREE_D_COVER_IMAGE_WIDTHS[number];

export const SMALLEST_THREE_D_COVER_IMAGE_WIDTH: ThreeDCoverImageWidth =
  THREE_D_COVER_IMAGE_WIDTHS[0];

export const LARGEST_THREE_D_COVER_IMAGE_WIDTH: ThreeDCoverImageWidth =
  THREE_D_COVER_IMAGE_WIDTHS[THREE_D_COVER_IMAGE_WIDTHS.length - 1];

export const THREE_D_COVER_IMAGE_ASPECT_RATIO = LARGEST_THREE_D_COVER_IMAGE_WIDTH / 1640;

export const SQUARE_COVER_IMAGE_SIZES = [
  90,
  180,
  270,
  300,
  450,
  600,
  750,
  900,
  1150,
  1400,
] as const;

export type SquareCoverImageSize = typeof SQUARE_COVER_IMAGE_SIZES[number];

export const SMALLEST_SQUARE_COVER_IMAGE_SIZE: SquareCoverImageSize =
  SQUARE_COVER_IMAGE_SIZES[0];

export const LARGEST_SQUARE_COVER_IMAGE_SIZE: SquareCoverImageSize =
  SQUARE_COVER_IMAGE_SIZES[SQUARE_COVER_IMAGE_SIZES.length - 1];
