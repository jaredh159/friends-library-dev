type UUID = string;

type Result<Value, Error = string> =
  | {
      success: true;
      value: Value;
    }
  | {
      success: false;
      error: Error;
    };
