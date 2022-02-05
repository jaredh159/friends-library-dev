import React from 'react';
import Button from '../Button';
import { CloudUploadIcon } from '@heroicons/react/solid';

interface Props {
  onSave(): unknown;
  disabled: boolean;
  buttonText?: string;
}

const SaveChangesBar: React.FC<Props> = ({
  onSave,
  disabled,
  buttonText = `Save Changes`,
}) => (
  <div className="border-t border-gray-200/60 fixed bottom-0 left-0 right-0 bg-gray-100 p-3 z-10 flex justify-center">
    <Button type="button" onClick={onSave} small disabled={disabled}>
      <CloudUploadIcon className="w-[16px] h-[16px] -translate-x-2" />
      {buttonText}
    </Button>
  </div>
);

export default SaveChangesBar;
