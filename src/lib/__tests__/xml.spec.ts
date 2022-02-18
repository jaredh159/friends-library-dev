import { partTitle, partDesc, subtitle } from '../xml';
import { Lang } from '../../graphql/globalTypes';

describe(`subtitle()`, () => {
  const cases: Array<[Parameters<typeof subtitle>, string]> = [
    [
      [
        { reader: `Jason R. Henderson` },
        { title: `A Letter of Elizabeth Webb` },
        { name: `Elizabeth Webb`, lang: Lang.en, isCompilations: false },
      ],
      `Audiobook of Elizabeth Webb's "A Letter of Elizabeth Webb" from The Friends Library. Read by Jason R. Henderson.`,
    ],
    [
      [
        { reader: `Keren Alvaredo` },
        { title: `A Letter of Elizabeth Webb` },
        { name: `Elizabeth Webb`, lang: Lang.es, isCompilations: false },
      ],
      `Audiolibro de "La Carta de Elizabeth Webb" escrito por Elizabeth Webb, de la Biblioteca de los Amigos. Leído por Keren Alvaredo.`,
    ],
    [
      [
        { reader: `Jason R. Henderson` },
        { title: `Truth in the Inward Parts -- Volume 1` },
        { name: `Compilations`, lang: Lang.en, isCompilations: true },
      ],
      `Audiobook of "Truth in the Inward Parts -- Volume 1" from The Friends Library. Read by Jason R. Henderson.`,
    ],
    [
      [
        { reader: `Keren Alvaredo` },
        { title: `La Verdad en Lo Íntimo` },
        { name: `Compilaciones`, lang: Lang.es, isCompilations: true },
      ],
      `Audiolibro de "La Verdad en Lo Íntimo", de la Biblioteca de los Amigos. Leído por Keren Alvaredo.`,
    ],
  ];

  test.each(cases)(`subtitle`, (args, expected) => {
    expect(subtitle(...args)).toBe(expected);
  });
});

describe(`partTitle()`, () => {
  it(`should use full title for standalone audio part`, () => {
    expect(partTitle({ title: `A Letter of Elizabeth Webb` }, 1, 1)).toBe(
      `A Letter of Elizabeth Webb`,
    );
  });

  it(`it should append short part identifier to title for multi-part audio`, () => {
    expect(partTitle({ title: `Saved to the Uttermost` }, 1, 5)).toBe(
      `Saved to the Uttermost, pt. 1`,
    );
  });
});

describe(`partDesc()`, () => {
  const cases: Array<[Parameters<typeof partDesc>, string]> = [
    [
      [
        { title: `The Life of Elizabeth Webb` },
        { title: `A Letter of Elizabeth Webb` },
        { name: `Elizabeth Webb`, lang: Lang.en },
        1,
        1,
      ],
      `Audiobook version of "A Letter of Elizabeth Webb" by Elizabeth Webb`,
    ],
    [
      [
        { title: `La Carta de Elizabeth Webb` },
        { title: `A Letter of Elizabeth Webb` },
        { name: `Elizabeth Webb`, lang: Lang.es },
        1,
        1,
      ],
      `Audiolibro de "La Carta de Elizabeth Webb" escrito por Elizabeth Webb`,
    ],
    [
      [
        { title: `Capítulo 1` },
        { title: `Los Escritos de Isaac Penington -- Volumen 1` },
        { name: `Isaac Penington`, lang: Lang.es },
        1,
        19,
      ],
      `Cp. 1. Parte 1 de 19 del audiolibro de "Los Escritos de Isaac Penington -- Volumen 1" escrito por Isaac Penington`,
    ],
    [
      [
        { title: `Chapter 1 - The Condition of Man in the Fall` },
        { title: `Saved to the Uttermost` },
        { name: `Robert Barclay`, lang: Lang.en },
        1,
        6,
      ],
      `Ch. 1 - The Condition of Man in the Fall. Part 1 of 6 of the audiobook version of "Saved to the Uttermost" by Robert Barclay`,
    ],
  ];

  test.each(cases)(`partDesc()`, (args, expected) => {
    expect(partDesc(...args)).toBe(expected);
  });

  it(`should not prepend \`part x\` if that is the audio part title`, () => {
    expect(
      partDesc(
        { title: `Part 1` },
        { title: `Walk in the Spirit` },
        { name: `Hugh Turford`, lang: Lang.en },
        1,
        3,
      ),
    ).toBe(
      `Part 1 of 3 of the audiobook version of "Walk in the Spirit" by Hugh Turford`,
    );
  });
});
