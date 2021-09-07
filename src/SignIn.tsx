import React, { useState } from 'react';
import cx from 'classnames';

interface Props {
  setToken(token: string): unknown;
}

const SignIn: React.FC<Props> = ({ setToken }) => {
  const [input, setInput] = useState(``);
  const validInput = input.length === 36;
  return (
    <div className="min-h-screen bg-white flex">
      <div className="flex-1 flex flex-col justify-center py-12 px-4 sm:px-6 lg:flex-none lg:px-20 xl:px-24">
        <div className="mx-auto w-full max-w-sm lg:w-96">
          <div className="mt-8">
            <div className="mt-6">
              <form
                onSubmit={(event) => {
                  event.preventDefault();
                  if (validInput) {
                    setToken(input);
                  }
                }}
                className="space-y-6"
              >
                <div>
                  <label
                    htmlFor="email"
                    className="block text-sm font-light text-gray-600 antialiased"
                  >
                    Enter Authorization Token:
                  </label>
                  <div className="mt-1">
                    <input
                      type="text"
                      placeholder="f4fb5d0c-7643-41ee-be31-6992b9fc3593"
                      required
                      spellCheck={false}
                      value={input}
                      onChange={(e) => setInput(e.target.value)}
                      className="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-300 focus:outline-none focus:ring-flprimary-500 focus:border-flprimary-500 sm:text-sm"
                    />
                  </div>
                </div>
                <div>
                  <button
                    type="submit"
                    disabled={!validInput}
                    className={cx(
                      !validInput && `opacity-75 bg-gray-400 cursor-not-allowed`,
                      validInput && `bg-flprimary`,
                      `font-sans antialiased w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm text-white hover:bg-flprimary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-flprimary-500`,
                    )}
                  >
                    Authorize
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div className="hidden lg:block relative w-0 flex-1">
        <div
          className="inset-0 absolute xbg-contain"
          style={{
            backgroundSize: `120%`,
            backgroundPosition: `0 0%`,
            backgroundImage: `radial-gradient(rgba(0, 0, 0, 0.55), rgba(0, 0, 0, 0.975) 65%), url(https://raw.githubusercontent.com/friends-library-dev/design-assets/master/hi-res-images/books.png)`,
          }}
        />
      </div>
    </div>
  );
};

export default SignIn;
