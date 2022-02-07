import React from 'react';
import cx from 'classnames';
import { MutationStep } from '../types';
import {
  CheckCircleIcon,
  PaperAirplaneIcon,
  ExclamationIcon,
  BackspaceIcon,
} from '@heroicons/react/solid';

interface Props {
  steps: MutationStep[];
  error?: string;
}

const Progress: React.FC<Props> = ({ steps }) => {
  const percentComplete =
    (steps.filter((step) => step.status === `succeeded`).length / steps.length) * 100;

  return (
    <div className="p-4 inline-flex flex-col">
      <table className="text-sm antialiased">
        <thead>
          <tr className="italic opacity-50 text-xs">
            <td>Step</td>
            <td>Description</td>
            <td>Status</td>
          </tr>
        </thead>
        {steps.map((step, index) => (
          <tr key={`step-${index}`} className={cx(``, index % 2 && `xbg-gray-50`)}>
            <td className="pr-6 text-gray-500">
              {index + 1}/{steps.length}
            </td>
            <td className="pr-6">{step.description}</td>
            <td className="pr-6 italic">
              <Status status={step.status} />
            </td>
          </tr>
        ))}
      </table>
      <div className="h-4 relative mt-5 bg-gray-200 rounded-full">
        <div
          className="absolute top-0 left-0 bg-flprimary h-4 rounded-full transition-all"
          style={{ width: `${percentComplete}%` }}
        />
      </div>
    </div>
  );
};

export default Progress;

const Status: React.FC<{ status: MutationStep['status'] }> = ({ status }) => {
  switch (status) {
    case `succeeded`:
    case `rollback succeeded`:
      return (
        <span className="flex items-center text-green-600/60">
          <CheckCircleIcon className="mr-1 w-[15px] h-[15px]" />
          {status === `succeeded` ? `complete` : status}
        </span>
      );
    case `rollback failed`:
    case `failed`:
      return (
        <span className="flex items-center text-red-600">
          <ExclamationIcon className="mr-1 w-[16px] h-[16px]" />
          {status}
        </span>
      );
    case `rolling back`:
      return (
        <span className="flex items-center text-orange-600">
          <BackspaceIcon className="mr-1 w-[17px] h-[17px]" />
          rolling back...
        </span>
      );
    case `in flight`:
      return (
        <span className="flex items-center text-purple-600">
          <PaperAirplaneIcon className="ml-1 mr-0.5 -translate-y-[2px] w-[15px] h-[15px] rotate-45" />
          in flight...
        </span>
      );
    case `no rollback`:
      return <span className="text-gray-400">no rollback possible</span>;
    case `not started`:
      return <span className="text-gray-400">waiting...</span>;
  }
};
