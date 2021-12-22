export type File = {
  path: string;
  source: string;
};

export type Model = {
  filepath: string;
  name: string;
  migrationNumber?: number;
  props: Array<{ identifier: string; type: string }>;
};
