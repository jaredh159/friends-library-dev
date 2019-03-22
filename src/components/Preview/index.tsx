import React from 'react';
import debounce from 'lodash/debounce';
import { connect } from 'react-redux';
import styled from '@emotion/styled/macro';
import { Global, css } from '@emotion/core';
import { Uuid, Html } from '@friends-library/types';
import { embeddablePdfHtml } from '@friends-library/asciidoc';
import { State as AppState } from '../../type';
import chapterJob from '../../lib/chapter-job';
import Centered from '../Centered';
import throbber from '../../assets/throbber.gif';

const Rendered = styled.div`
  background: #eaeaea;
  color: black;
  min-height: 100vh;

  .page {
    background: white;
    max-width: 650px;
    padding: 0 75px 75px 75px;
    margin: auto;
    min-height: 100vh;
  }
`;

const globalStyles = css`
  html {
    font-size: 12.5pt !important;
    background: #eaeaea;
    counter-reset: footnotes;
  }

  h2 {
    margin-top: 0 !important;
    padding-top: 1.125in !important;
  }

  .footnote {
    counter-increment: footnotes;
    font-size: 0 !important;
    width: 0;
  }

  span.footnote::before {
    content: counter(footnotes);
    font-size: 0.85rem;
    display: inline-block;
    transform: translateY(-7px);
  }
`;

type OwnProps = {
  taskId: Uuid;
  file: string;
};

type Props = OwnProps & {
  getHtml: () => Html;
};

type State = {
  cssLoaded: boolean;
  html: Html;
};

class Component extends React.Component<Props, State> {
  state: State = { cssLoaded: false, html: '' };

  componentDidMount() {
    const link = document.createElement('link');
    link.setAttribute('rel', 'stylesheet');
    link.type = 'text/css';
    link.href = 'https://flp-styleguide.netlify.com/pdf.css';
    document.head.appendChild(link);
    window.addEventListener('scroll', this.watchScroll);

    link.onload = () => {
      this.setState({ cssLoaded: true });
      this.restoreScroll();
    };

    // prepping HTML for a big file can take 1-5 SECONDS
    // so defer so that we can show the throbber while waiting
    const { getHtml } = this.props;
    setTimeout(() => {
      this.setState({ html: getHtml() });
      this.restoreScroll();
    }, 100);
  }

  componentWillUnmount() {
    window.removeEventListener('scroll', this.watchScroll);
  }

  restoreScroll() {
    const savedScroll = sessionStorage.getItem(this.scrollKey());
    if (savedScroll) {
      window.scrollTo(0, Number(savedScroll));
    }
  }

  scrollKey() {
    const { taskId, file } = this.props;
    return `scroll:${taskId}--${file}`;
  }

  watchScroll = debounce(() => {
    sessionStorage.setItem(this.scrollKey(), String(window.scrollY));
  }, 200);

  render() {
    const { cssLoaded, html } = this.state;
    return (
      <Rendered className="body">
        <Global styles={globalStyles} />
        <div className="page">
          {cssLoaded && html ? (
            <div className="inner" dangerouslySetInnerHTML={{ __html: html }} />
          ) : (
            <Centered>
              <h1 style={{ height: '100vh', opacity: 0.8, lineHeight: '100vh' }}>
                <img src={throbber} style={{ height: 45 }} />
              </h1>
            </Centered>
          )}
        </div>
      </Rendered>
    );
  }
}

const mapState = (state: AppState, { taskId, file }: OwnProps): Props => {
  console.log(file);
  const getHtml = (): Html => {
    const job = chapterJob(state, taskId, file);
    job.spec.conversionLogs.forEach(log => {
      console.warn(
        `${log.getSeverity()}: ${log.getText()}${
          log.getSourceLocation()
            ? ` (near line ${(log.getSourceLocation() as any).getLineNumber()})`
            : ''
        }`,
      );
    });
    return embeddablePdfHtml(job);
  };
  return {
    taskId,
    file,
    getHtml,
  };
};

export default connect(mapState)(Component);
