export type File = {
  path: string;
  source: string;
};

export type Model = {
  filepath: string;
  name: string;
  migrationNumber?: number;
  dbEnums: Record<string, string[]>;
  props: Array<{ name: string; type: string }>;
  init: Array<{ propName: string; hasDefault: boolean }>;
  taggedTypes: Record<string, string>;
};

export type GlobalTypes = {
  dbEnums: Record<string, string[]>;
  taggedTypes: Record<string, string>;
};
