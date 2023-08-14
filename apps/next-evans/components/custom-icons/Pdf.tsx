import React from 'react';
import cx from 'classnames';

interface Props {
  tailwindColor?: string;
  className?: string;
}

const Pdf: React.FC<Props> = ({ tailwindColor = `white`, className }) => (
  <svg
    className={cx(className, `inline-block`)}
    style={{ transform: `translateX(25%)` }}
    width="30"
    height="40"
    viewBox="0 0 24 30"
  >
    <g className={cx(`text-${tailwindColor}`, `fill-current`)}>
      <path d="M21.8114337 3.30345569C21.8520038 3.35197483 21.9103242 3.38028169 21.9711793 3.38028169 22.0333035 3.38028169 22.0903548 3.35197794 22.1309249 3.30345569L23.6079365 1.7198037C23.663722 1.65241447 23.6776651 1.55671839 23.6434369 1.47585201 23.6079365 1.39498217 23.5318691 1.3424192 23.4481941 1.3424192L22.9182511 1.3424192 22.9182511.226430699C22.9182511.101085565 22.8231646 0 22.7052581 0L21.2371395 0C21.1192331 0 21.0241465.101085565 21.0241465.226430699L21.0241465 1.3424192 20.4954693 1.3424192C20.4117943 1.3424192 20.3344579 1.39498217 20.3002265 1.47585201 20.265995 1.55806748 20.2799414 1.65241447 20.3357269 1.7198037L21.8114337 3.30345569zM14.8135413 13.5819496C14.1855857 12.8818654 13.5667354 12.0996815 13.0091197 11.3969942 12.7459507 11.0645602 12.494495 10.7477719 12.2586948 10.459655L12.2417582 10.4387964C12.5870204 9.45583511 12.7837317 8.65145755 12.8280235 8.04785732 12.9400669 6.50952112 12.7680929 5.51744879 12.3029929 5.01814198 11.9890118 4.68049831 11.5173814 4.56185412 11.0744307 4.71177966 10.756544 4.81867957 10.3266073 5.10418988 10.0816686 5.85770563 9.71556133 6.98147135 9.89275831 8.97085571 10.9337177 10.6161552 10.468621 11.8337683 9.82112109 13.2326017 9.10584947 14.5649542 7.74311127 15.0434023 6.65786352 15.671766 5.87745502 16.4331246 4.85864488 17.4278335 4.44564439 18.4146995 4.74141184 19.1408486 4.92380844 19.5906286 5.34592075 19.8591549 5.8696506 19.8591549 6.23445714 19.8591549 6.62918061 19.7274849 7.01093008 19.4784923 7.97500923 18.8475255 9.2335551 16.7460049 9.90970457 15.5283584 11.3063286 15.0916276 12.6860097 14.9130105 13.3870066 14.8452282 13.7035925 14.8139401 14.0188643 14.790475 14.3224362 14.7735277 15.5496977 16.0706708 16.5528656 16.753801 17.477856 16.9245752 17.6641581 16.9597746 17.850467 16.9767219 18.0315695 16.9767219 18.7845958 16.9767219 19.4073484 16.6755759 19.6978796 16.1723443 19.9167535 15.7916817 19.9128446 15.3484097 19.6861543 14.9547312 19.1728303 14.0656174 17.6250874 13.5767566 15.3270196 13.5767566 15.1615626 13.5741491 14.990896 13.5767566 14.8136957 13.5819709L14.8135413 13.5819496zM6.37142835 18.497924C6.18903175 18.6165581 6.00141887 18.6882586 5.86984438 18.6882586 5.8450907 18.6882586 5.82815411 18.6856511 5.81773154 18.6830439 5.7942806 18.5670163 5.87766214 18.0624898 6.69322721 17.2659551 7.07624406 16.8918004 7.56091846 16.550252 8.13414299 16.2477844 7.40976622 17.4119659 6.75966482 18.2450116 6.37141168 18.497919L6.37142835 18.497924zM11.19049 6.21866764C11.2751746 5.95793411 11.3807011 5.84060819 11.4471453 5.81844792 11.4484484 5.81844792 11.4497511 5.81714434 11.4510539 5.81714434 11.5148934 5.88884481 11.783272 6.29689404 11.6634141 7.96298551 11.642569 8.25370215 11.5722158 8.62135229 11.452358 9.05804968 11.0628041 8.05422974 10.9546762 6.93827351 11.1904897 6.21866564L11.19049 6.21866764zM13.2750035 13.6807363C12.6535517 13.7407058 11.7077162 13.8632481 10.6524187 14.1135623 11.061517 13.2961689 11.4406317 12.4670279 11.7572109 11.6991614 11.8666462 11.8360478 11.9786896 11.9781471 12.0933345 12.122843 12.4750506 12.6038943 12.9036933 13.14622 13.3492456 13.674195L13.2750035 13.6807363zM18.6740602 15.5358575C18.6909968 15.5658419 18.6909968 15.5775749 18.6870883 15.5853977 18.6375803 15.6701373 18.4161015 15.8057188 18.0304499 15.8057188 17.9223153 15.8057188 17.8076671 15.7952894 17.6891233 15.7731272 17.2070837 15.6844794 16.6455658 15.3507472 15.97592 14.756258 17.793349 14.8436042 18.5268309 15.2816299 18.6740476 15.5358388L18.6740602 15.5358575z" />
      <path d="M16.9022915,0 L1.69022243,0 C0.758503778,0 0,0.749996667 0,1.67705921 L0,28.3229408 C0,29.2487033 0.75719358,30 1.69022243,30 L21.9717494,30 C22.9060884,30 23.6619718,29.2487033 23.6619718,28.3229408 L23.6619718,6.70837019 L16.9022915,0 Z M16.9022915,2.37108946 L21.2736491,6.70840352 L16.9022915,6.70840352 L16.9022915,2.37108946 Z M21.9731604,28.3226408 L1.69022243,28.3226408 L1.69022243,1.67675921 L15.2121363,1.67675921 L15.2121363,6.70807019 C15.2121363,7.63383274 15.9680197,8.3851294 16.9023587,8.3851294 L21.9731604,8.3851294 L21.9731604,28.3226408 Z" />
      <path d="M9.3068284 21.4749516C9.1726375 21.3508838 9.01161235 21.2601655 8.82759389 21.2081382 8.64611751 21.1547755 8.3879466 21.1267606 8.05695155 21.1267606L6.96169391 21.1267606C6.75338002 21.1267606 6.59618272 21.1761206 6.49394297 21.2761761 6.39170322 21.3762315 6.33802817 21.5389868 6.33802817 21.7591211L6.33802817 25.1516553C6.33802817 25.3490955 6.38531364 25.5025 6.47732942 25.6092253 6.57062442 25.7186179 6.69586729 25.7746479 6.84922037 25.7746479 6.9949112 25.7746479 7.1175989 25.7186179 7.21473157 25.6092253 7.30930252 25.5011646 7.356588 25.3450792 7.356588 25.1462934L7.356588 23.985668 8.0569221 23.985668C8.59750047 23.985668 9.01287194 23.8629322 9.29145481 23.618806 9.57389171 23.3720024 9.71830986 23.0077906 9.71830986 22.5342033 9.71830986 22.3140827 9.68380353 22.1126296 9.61479089 21.9352094 9.54450228 21.7537763 9.44226253 21.6003582 9.30679241 21.4749413L9.3068284 21.4749516zM8.59880586 22.8930498C8.53746201 22.9797654 8.45055659 23.039798 8.33170329 23.0784855 8.20518119 23.1198403 8.04415277 23.1411853 7.85116011 23.1411853L7.3578574 23.1411853 7.3578574 21.9672065 7.85116011 21.9672065C8.2959112 21.9672065 8.47611489 22.0592567 8.54766636 22.1352998 8.64351653 22.2420251 8.68952279 22.3781008 8.68952279 22.5515457 8.68952279 22.6929559 8.65885086 22.8090219 8.59878623 22.8930668L8.59880586 22.8930498zM13.2507034 21.553984C13.071335 21.3885207 12.8687564 21.2745928 12.6480848 21.214919 12.4338747 21.1565992 12.1732113 21.1267606 11.8751393 21.1267606L10.7512004 21.1267606C10.543442 21.1267606 10.3885787 21.1796535 10.2892435 21.2827313 10.1898817 21.3871631 10.1408451 21.5499147 10.1408451 21.7682606L10.1408451 25.0490552C10.1408451 25.2023143 10.1537494 25.3257347 10.1795584 25.4247293 10.2092378 25.5372996 10.2737601 25.6254546 10.3718302 25.6864895 10.4647402 25.7461668 10.5950719 25.7746479 10.767982 25.7746479L11.891921 25.7746479C12.0906444 25.7746479 12.2725796 25.7610854 12.4325996 25.7339591 12.5951929 25.7068338 12.750043 25.6580084 12.8906915 25.5901961 13.0339265 25.5223838 13.1668416 25.428802 13.2868433 25.3162317 13.4378217 25.1697535 13.5642818 25.0029362 13.6610602 24.8171268 13.7565502 24.632675 13.8301053 24.4224607 13.8752703 24.193237 13.9204353 23.9667423 13.943662 23.713124 13.943662 23.4391458 13.943662 22.600962 13.7100969 21.9675935 13.2506935 21.5539354L13.2507034 21.553984zM12.499693 24.6910364C12.4442046 24.7425753 12.3771046 24.783264 12.2996779 24.8117451 12.2196712 24.8415828 12.1409562 24.8605689 12.0674012 24.8673532 11.9886861 24.8754907 11.8790011 24.8795595 11.738346 24.8795595L11.1679692 24.8795595 11.1679692 22.0164853 11.654471 22.0164853C11.9086827 22.0164853 12.1280561 22.0463229 12.3035364 22.1032862 12.4687098 22.1561792 12.6106565 22.2836688 12.7254883 22.4844114 12.8442084 22.6892059 12.9035742 23.0079247 12.9035742 23.4310963 12.9048557 24.0292236 12.7693617 24.4523604 12.49965 24.6910628L12.499693 24.6910364zM17.6425095 21.1267606L15.4489008 21.1267606C15.3026579 21.1267606 15.1842722 21.1481253 15.0867876 21.1908276 14.983723 21.2361978 14.9057275 21.3095944 14.8569798 21.4096747 14.8110168 21.5030867 14.7887324 21.6178498 14.7887324 21.7592864L14.7887324 25.146119C14.7887324 25.3502903 14.8402647 25.5064233 14.9419388 25.6118465 15.0450034 25.7199378 15.1814983 25.7746479 15.3444492 25.7746479 15.504619 25.7746479 15.6383257 25.7212701 15.7441785 25.6131788 15.8458526 25.507759 15.8973849 25.3502937 15.8973849 25.1447867L15.8973849 23.779648 17.3403111 23.779648C17.5018715 23.779648 17.6286147 23.7422852 17.7163655 23.6688887 17.8068973 23.5914917 17.8528568 23.4887399 17.8528568 23.3619656 17.8528568 23.2351912 17.8082879 23.1311071 17.7191501 23.0550425 17.632797 22.9789779 17.5046633 22.9402795 17.3403147 22.9402795L15.8973885 22.9402795 15.8973885 21.9848087 17.6411368 21.9848087C17.8124488 21.9848087 17.9433708 21.9461103 18.0325228 21.8673776 18.1230547 21.788645 18.1690141 21.6832252 18.1690141 21.5537828 18.1690141 21.4283441 18.1230511 21.3229243 18.0311287 21.2428559 17.9433851 21.165459 17.8124631 21.1267606 17.6425594 21.1267606L17.6425095 21.1267606z" />
    </g>
  </svg>
);

export default Pdf;
