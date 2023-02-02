import React, { useState } from 'react';
import { CloudUploadIcon, TrashIcon } from '@heroicons/react/solid';
import type { EditableEntity, WorkItem } from '../types';
import { save } from '../lib/api/entities';
import { isClientGeneratedId } from '../lib/api/entities/helpers';
import Progress from './Progress';
import Button from './Button';

interface Props {
  getEntities<T extends EditableEntity>(): [T, T?];
  disabled: boolean;
  entityName: string;
}

const SaveChangesBar: React.FC<Props> = ({ getEntities, disabled, entityName }) => {
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | undefined>();
  const [steps, setSteps] = useState<WorkItem[]>([]);

  if (error) {
    return (
      <div className="fixed inset-0 flex items-center justify-center bg-gray-200/80 z-10">
        <div className="text-red-700 bg-white p-8 rounded-lg mx-16">{error}</div>
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

  const [current, previous] = getEntities();

  function persist<T extends EditableEntity>(current?: T, previous?: T): void {
    save(
      (steps, error) => {
        setSteps(steps);
        setError(error);
      },
      current,
      previous,
    );
  }

  return (
    <div className="border-t border-gray-200/60 fixed bottom-0 space-x-4 left-0 right-0 bg-gray-100 p-3 z-10 flex justify-center">
      <Button
        type="button"
        onClick={() => {
          setSaving(true);
          persist(current, previous);
        }}
        small
        disabled={disabled}
      >
        <CloudUploadIcon className="w-[16px] h-[16px] -translate-x-2" />
        Save {entityName}
      </Button>
      {!isClientGeneratedId(current?.id) && (
        <Button
          type="button"
          className="hover:text-red-700"
          onClick={() => {
            setSaving(true);
            persist(undefined, previous);
          }}
          small
          secondary
        >
          <TrashIcon className="w-[16px] h-[16px] -translate-x-2" />
          Delete {entityName}
        </Button>
      )}
    </div>
  );
};

export default SaveChangesBar;
