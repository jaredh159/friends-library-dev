import css from 'x-syntax';

export default css`
  .copyright-page {
    page: copyright;
    display: flex;
  }

  .copyright-page a {
    color: black;
    text-decoration: none;
    font-style: italic;
  }

  .copyright-page ul {
    list-style-type: none;
    padding: 0;
    margin: auto 0 0 0;
  }

  .copyright-page ul li {
    padding-bottom: 0.85em;
  }

  .copyright-page ul li.debug {
    font-size: 0.8em;
  }

  @page copyright {
    @bottom-center {
      content: normal;
    }
    @top-center {
      content: normal;
    }
  }
`;
