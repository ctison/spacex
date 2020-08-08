// https://nextjs.org/docs/advanced-features/custom-app

import { AppProps } from 'next/app'
import { CssBaseline } from '@material-ui/core'
import { makeStyles } from '@material-ui/core/styles'
import Head from 'next/head'
import { Header, Drawer } from '@/components'
import { SWRConfig } from 'swr'

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  main: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
}))

const App = ({ Component, pageProps }: AppProps): JSX.Element => {
  const classes = useStyles()
  return (
    <>
      <Head>
        <meta
          name='viewport'
          content='minimum-scale=1, initial-scale=1, width=device-width'
        />
        <link
          rel='stylesheet'
          href='https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap'
        />
        <link
          rel='stylesheet'
          href='https://fonts.googleapis.com/icon?family=Material+Icons'
        />
      </Head>
      <CssBaseline />
      <SWRConfig
        value={{
          fetcher: (key: string) => fetch(key).then((res) => res.json()),
          revalidateOnFocus: false,
          revalidateOnReconnect: false,
        }}
      >
        <Header />
        <div className={classes.root}>
          <Drawer />
          <main className={classes.main}>
            <Component {...pageProps} />
          </main>
        </div>
      </SWRConfig>
    </>
  )
}

export default App
