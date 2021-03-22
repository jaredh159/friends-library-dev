import css from 'x-syntax';

export default css`
  .signed-section-context-open {
    margin-top: 2em;
    margin-bottom: 0;
  }

  .signed-section-context-open + .paragraph {
    margin-top: 0.75em;
  }

  .signed-section-context-open,
  .signed-section-context-close {
    font-style: italic;
    font-size: 0.9em;
  }

  .signed-section-context-close {
    margin-bottom: 2.5em;
  }

  .signed-section-context-close + .signed-section-signature {
    margin-top: -1.5em;
  }

  .signed-section-closing {
    text-align: right;
    margin-top: 0.5em;
  }

  .signed-section-closing + .signed-section-signature {
    margin-top: -0.5em;
  }

  .salutation {
    margin-top: 1em;
    margin-bottom: 0.5em;
  }

  .signed-section-context-open + .salutation {
    margin-top: 0.75em;
  }

  .signed-section-context-open + .signed-section-context-open {
    margin-top: 0.1em;
  }

  .signed-section-signature {
    margin-top: 0.45em;
    margin-bottom: 2.5em;
    padding-left: 3em;
    font-variant: small-caps;
  }

  .signed-section-signature::before {
    content: '\\2014';
  }

  .paragraph + .postscript {
    margin-top: 1em;
  }

  .signed-section-context-close + .postscript,
  .signed-section-signature + .postscript {
    margin-top: -1.85em;
  }

  .postscript .paragraph:first-of-type {
    text-indent: 0;
  }

  .signed-section-signature,
  .signed-section-context-close {
    text-align: right;
    text-indent: 0;
  }

  .salutation {
    margin-bottom: 0.5em;
  }

  .letter-heading + .signed-section-context-open {
    margin-top: 0.5em;
  }

  .signed-section-context-close + .signed-section-context-close,
  .signed-section-signature + .signed-section-signature {
    margin-top: -2.5em;
  }

  .signed-section-signature + .signed-section-context-close {
    margin-top: -2.25em;
  }

  .offset + .embedded-content-document {
    margin-top: -0.5em;
  }

  .offset + .embedded-content-document .letter-heading {
    margin-top: 1.75em;
  }
`;
