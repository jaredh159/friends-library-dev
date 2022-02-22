export type File = {
  path: string;
  source: string;
};

export type GlobalTypes = {
  dbEnums: Record<string, string[]>;
  taggedTypes: Record<string, string>;
};
