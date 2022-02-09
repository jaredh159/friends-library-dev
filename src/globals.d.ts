type UUID = string;

type IdentifyEntity = {
  id: UUID;
};

type Result<Value, Error = string> =
  | {
      success: true;
      value: Value;
    }
  | {
      success: false;
      error: Error;
    };
