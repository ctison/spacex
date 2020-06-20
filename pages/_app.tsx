// https://nextjs.org/docs/advanced-features/custom-app

import { AppProps } from 'next/app'
import { CssBaseline } from '@material-ui/core'
import Head from 'next/head'
import Header from '@/components/Header'

const App = ({ Component, pageProps }: AppProps): JSX.Element => {
  return (
    <>
      <Head>
        <meta name='viewport' content='minimum-scale=1, initial-scale=1, width=device-width' />
        <link
          rel='stylesheet'
          href='https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap'
        />
        <link rel='stylesheet' href='https://fonts.googleapis.com/icon?family=Material+Icons' />
      </Head>
      <CssBaseline />
      <Header />
      <Component {...pageProps} />
    </>
  )
}

export default App
