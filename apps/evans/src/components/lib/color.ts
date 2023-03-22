import { LANG } from '../env';

// TODO: import from @friends-library/theme when converting to next/astro
// was getting funky errors in storybook, i think maybe converting to a
// real tailwind preset instead of how it's done now might fix it
const BLACK_RGB = [45, 42, 41];
const MAROON_RGB = [108, 49, 66];
const GOLD_RGB = [193, 140, 89];
const BLUE_RGB = [95, 140, 158];

export function bgLayer(
  color: string | [number, number, number],
  opacity?: number,
): string {
  let colorStr = ``;
  if (typeof color === `string`) {
    switch (color) {
      case `flprimary`:
        colorStr =
          LANG === `en` ? `rgb(${MAROON_RGB.join(`,`)})` : `rgb(${GOLD_RGB.join(`,`)})`;
        break;
      case `flblue`:
        colorStr = `rgb(${BLUE_RGB.join(`,`)})`;
        break;
      case `black`:
        colorStr = `rgb(${BLACK_RGB.join(`,`)})`;
        break;
      default:
        if (color.startsWith(`#`)) {
          colorStr = color;
        } else {
          throw new Error(`Unsupported color string: ${color}`);
        }
    }
  } else {
    colorStr = `rgb(${color.join(`, `)})`;
  }
  if (opacity) {
    colorStr = colorStr.replace(`)`, `, ${opacity})`).replace(`rgb(`, `rgba(`);
  }

  return `linear-gradient(${colorStr}, ${colorStr})`;
}
