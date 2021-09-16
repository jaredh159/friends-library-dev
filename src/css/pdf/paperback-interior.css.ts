import css from 'x-syntax';

export default css`
  html {
    font-size: 10pt;
  }

  @page {
    size: var(--page-width) var(--page-height);
    margin-top: var(--page-top-margin);
    margin-bottom: var(--page-bottom-margin);

    @top-center {
      margin-top: var(--running-head-margin-top);
    }
  }

  @page:left {
    margin-left: var(--page-outer-margin);
    margin-right: var(--page-inner-margin);
  }

  @page:right {
    margin-left: var(--page-inner-margin);
    margin-right: var(--page-outer-margin);
  }

  .chapter {
    /* forces new page & allows target @page:first for pages starting chapters */
    prince-page-group: start;
    page-break-before: recto; /* keep start of chapters on recto */
    margin-top: var(--chapter-margin-top);
  }

  .chapter.intermediate-title {
    margin-top: 1.75in;
  }

  .copyright-page {
    height: var(--copyright-page-height);
  }

  .half-title-page {
    height: var(--half-title-page-height);
  }

  blockquote > p {
    font-size: 0.98rem;
  }

  .chapter blockquote > p + p {
    margin-top: 0.4em;
  }

  .chapter-1 {
    counter-reset: page 1;
  }
`;
