import css from 'x-syntax';

export default css`
  .footnote .poetry {
    margin-top: 0.4em;
    margin-bottom: 0.4em;
  }

  .footnote .verse-stanza {
    margin-bottom: 0;
  }

  .footnote .verse-stanza + .verse-stanza {
    margin-top: 0.45em;
  }

  .footnote .verse-line {
    line-height: 1.2em;
  }
`;
