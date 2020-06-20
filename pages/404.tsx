// https://nextjs.org/docs/advanced-features/custom-error-page

import { NextPage } from 'next'
import Error from 'next/error'

export const Page: NextPage = () => {
  return <Error statusCode={404} />
}

export default Page
