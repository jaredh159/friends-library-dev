type UUID = string;
type Int64 = number;

type IdentifyEntity = {
  id: UUID;
};

type Result<Value, Error = string> =
  | { success: true; value: Value }
  | { success: false; error: Error };
