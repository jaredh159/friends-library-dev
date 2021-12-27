export type File = {
  path: string;
  source: string;
};

export type Model = {
  filepath: string;
  name: string;
  migrationNumber?: number;
  props: Array<{ identifier: string; type: string }>;
  taggedTypes: Record<string, string>;
};

export type GlobalTypes = {
  dbEnums: Array<string>;
  taggedTypes: Record<string, string>;
};
