import React, { useState } from 'react';
import Button from '../Button';
import { CloudUploadIcon } from '@heroicons/react/solid';
import { EditableEntity, WorkItem } from '../../types';
import { save } from '../../lib/api/entities';
import Progress from '../Progress';

interface Props {
  getEntities<T extends EditableEntity>(): [T, T?];
  disabled: boolean;
  buttonText?: string;
}

const SaveChangesBar: React.FC<Props> = ({
  getEntities,
  disabled,
  buttonText = `Save Changes`,
}) => {
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | undefined>();
  const [steps, setSteps] = useState<WorkItem[]>([]);

  if (error) {
    return (
      <div className="fixed inset-0 flex items-center justify-center bg-gray-200/80 z-10">
        <div className="text-red-700 bg-white p-8 rounded-lg mx-16">Error: {error}</div>
      </div>
    );
  }

  if (saving && steps.length > 0) {
    return (
      <div className="fixed inset-0 flex items-center justify-center bg-gray-200/80 z-10">
        <Progress items={steps} />
      </div>
    );
  }

  return (
    <div className="border-t border-gray-200/60 fixed bottom-0 left-0 right-0 bg-gray-100 p-3 z-10 flex justify-center">
      <Button
        type="button"
        onClick={() => {
          setSaving(true);
          const [current, previous] = getEntities();
          save(
            (steps, error) => {
              setSteps(steps);
              setError(error);
            },
            current,
            previous,
          );
        }}
        small
        disabled={disabled}
      >
        <CloudUploadIcon className="w-[16px] h-[16px] -translate-x-2" />
        {buttonText}
      </Button>
    </div>
  );
};

export default SaveChangesBar;
