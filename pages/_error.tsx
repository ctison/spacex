// https://nextjs.org/docs/advanced-features/custom-error-page

import { NextPage } from 'next'
import Error from 'next/error'

interface Props {
  statusCode: number
}

export const Page: NextPage<Props> = ({ statusCode }) => {
  return <Error statusCode={statusCode} />
}

export default Page
