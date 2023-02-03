import css from 'x-syntax';

export default css`
  .intermediate-title {
    page: intermediatetitle;
  }

  @page intermediatetitle {
    @bottom-center {
      content: normal;
    }
  }

  .intermediate-title > *,
  .intermediate-title .paragraph {
    line-height: 150%;
    text-align: center;
  }

  .intermediate-title .chapter-heading h2 {
    font-size: 2rem;
    margin-bottom: 18pt;
  }

  .intermediate-title h3.division {
    font-size: 1.4rem;
    font-variant: small-caps;
    margin-bottom: 3.75rem;
  }
`;
