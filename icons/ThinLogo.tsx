import React from 'react';
import cx from 'classnames';

interface Props {
  className?: string;
  height?: number;
}

const ThinLogo: React.FC<Props> = ({ className, height = 18 }) => {
  return (
    <svg
      className={cx(className, 'inline-block')}
      width={height}
      height={height}
      viewBox="0 0 24 24"
    >
      <path
        className="fill-current"
        d="M3 24L0 24 0 0 3 0 3 1.20461127 2.25735608 1.20461127C1.95767591 1.20461127 1.74371002 1.25673869 1.61513859 1.36166184 1.48656716 1.46625084 1.40405117 1.63666741 1.36759062 1.87224326 1.33113006 2.10781911 1.31289979 2.48774783 1.31289979 3.0113611L1.31289979 20.975607C1.31289979 21.4818445 1.32729211 21.8484072 1.35607676 22.0752952 1.38486141 22.3021831 1.4673774 22.4749387 1.60362473 22.5925596 1.73987207 22.7105146 1.95767591 22.769325 2.25735608 22.769325L3 22.769325 3 24zM15 18.1539043C15 19.1403857 14.7773922 20.0521838 14.3321765 20.8878805 13.8869608 21.7235772 13.2275657 22.4136888 12.3539911 22.9577425 11.4794249 23.5013235 10.442241 23.84827 9.24144769 24L9.24144769 22.6098506C10.442241 22.3881641 11.4070402 21.9930043 12.1368369 21.4238987 12.865642 20.854793 13.2305404 20.137266 13.2305404 19.2717905 13.2305404 19.050104 13.1819534 18.8685952 13.0857709 18.7277368 12.9890927 18.5868784 12.8497769 18.5164492 12.6673277 18.5164492 12.560238 18.5164492 12.3832424 18.5415012 12.1368369 18.5920779 11.9434804 18.6525808 11.6807139 18.6828323 11.3485374 18.6828323 10.7694596 18.6828323 10.2330193 18.4635092 9.73971244 18.0258083 9.24640555 17.5876347 9 17.0412176 9 16.386557 9 15.6614672 9.25979177 15.0824352 9.78036688 14.6494611 10.2999504 14.216487 10.9087754 14 11.6058503 14 12.1095687 14 12.6241943 14.1559841 13.1502231 14.468425 13.6752603 14.7803933 14.1150223 15.2511817 14.4690134 15.8803176 14.8230045 16.5099263 15 17.2676309 15 18.1539043M24 24L21 24 21 22.7957229 21.7484056 22.7957229C22.0478316 22.7957229 22.2611607 22.7432613 22.3877551 22.6386723 22.5143495 22.5337492 22.5959821 22.3636667 22.6323342 22.1277567 22.6686862 21.8918467 22.6871811 21.516262 22.6871811 21.0016708L22.6871811 3.03775897C22.6871811 2.5315215 22.6728316 2.16228559 22.6441327 1.93138784 22.6151148 1.70015594 22.5325255 1.52539541 22.3963648 1.40744041 22.2598852 1.28981956 22.0440051 1.23067498 21.7484056 1.23067498L21 1.23067498 21 0 24 0 24 24z"
      />
    </svg>
  );
};

export default ThinLogo;
