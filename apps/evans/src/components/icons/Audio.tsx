import React from 'react';
import cx from 'classnames';

interface Props {
  tailwindColor?: string;
  className?: string;
  height?: number;
}

const AudioIcon: React.FC<Props> = ({
  tailwindColor = `flgray-900`,
  className,
  height = 14,
}) => (
  <svg
    className={cx(className, `inline-block`)}
    width={(16 / 14) * height}
    height={height}
    viewBox="0 0 16 14"
  >
    <path
      className={cx(`text-${tailwindColor}`, `fill-current`)}
      d="M.999531931 9C.447258194 9 0 8.70123423 0 8.3331076L0 5.66687752C0 5.29875089.447258194 5 .999531931 5 1.55180567 5 2 5.29875089 2 5.66687752L2 8.3337476 2 8.33312248C2 8.51000182 1.89498446 8.68000119 1.7074447 8.80499273 1.51990495 8.92998426 1.2648672 9 .999531931 9L.999531931 9zM4.00046807 11C3.44819433 11 3 10.7119309 3 10.3569665L3 2.64303346C3 2.28806912 3.44819433 2 4.00046807 2 4.55274181 2 5 2.28806912 5 2.64303346L5 10.3569665C5 10.5275216 4.89498446 10.690841 4.7074447 10.8113635 4.51990495 10.931886 4.26582734 11 4.00046807 11L4.00046807 11zM15.0004681 9C14.4481943 9 14 8.70123423 14 8.3331076L14 5.66687752C14 5.29875089 14.4481943 5 15.0004681 5 15.5527418 5 16 5.29875089 16 5.66687752L16 8.3337476 16 8.33312248C16 8.51000182 15.8949845 8.68000119 15.7074447 8.80499273 15.5199049 8.92998426 15.2658273 9 15.0004681 9L15.0004681 9zM11.9995319 11C11.4472582 11 11 10.7119309 11 10.3569665L11 2.64303346C11 2.28806912 11.4472582 2 11.9995319 2 12.5518057 2 13 2.28806912 13 2.64303346L13 10.3569665C13 10.5275216 12.8949845 10.690841 12.7074447 10.8113635 12.5199049 10.931886 12.2648672 11 11.9995319 11zM8 14C7.44798464 14 7 13.7154156 7 13.3640112L7 .63598875C7 .284584385 7.44798464 0 8 0 8.55201536 0 9 .284584385 9 .63598875L9 13.3640112C9 13.5328558 8.89409549 13.6945372 8.70664587 13.813851 8.51919626 13.9331647 8.26523512 14 8 14L8 14z"
    />
  </svg>
);

export default AudioIcon;
