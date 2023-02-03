import css from 'x-syntax';

export default css`
  *::footnote-call {
    content: counter(footnote, symbols('*', '†', '‡', '§'));
  }

  *::footnote-marker {
    content: counter(footnote, symbols('*', '†', '‡', '§'));
  }
`;
