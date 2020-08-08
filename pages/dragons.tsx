import { NextPage } from 'next'
import { makeStyles } from '@material-ui/core/styles'
import Link from 'next/link'
import { Chip, TableCell, TableRow } from '@material-ui/core'
import { Breadcrumbs, Table } from '@/components'
import { useDragons } from '@/model/Dragon'

const useStyles = makeStyles(() => ({
  tableRow: {
    cursor: 'pointer',
  },
  chipTrue: {
    color: 'green',
  },
  chipFalse: {
    color: 'red',
  },
}))

export const Page: NextPage = () => {
  const classes = useStyles()
  const dragons = useDragons('?filter=id,name,active,type')
  return (
    <>
      <Breadcrumbs
        links={[{ label: 'SpaceX', href: '/spacex' }, { label: 'Dragons' }]}
      />
      <Table
        isValidating={dragons.isValidating}
        columns={['ID', 'Name', 'Active', 'Type']}
      >
        {dragons.data?.map((dragon) => (
          <Link key={dragon.id} href={`/dragon/${dragon.id}`}>
            <TableRow hover className={classes.tableRow}>
              <TableCell>{dragon.id}</TableCell>
              <TableCell>{dragon.name}</TableCell>
              <TableCell>
                <Chip
                  className={
                    dragon.active ? classes.chipTrue : classes.chipFalse
                  }
                  label={`${dragon.active}`}
                />
              </TableCell>
              <TableCell>{dragon.type}</TableCell>
            </TableRow>
          </Link>
        ))}
      </Table>
    </>
  )
}

export default Page
