import React from 'react'
import { makeStyles } from '@material-ui/core/styles'
import {
  LinearProgress,
  Paper,
  Table as MaterialTable,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Toolbar,
  Typography,
} from '@material-ui/core'

const useStyles = makeStyles(() => ({
  linearProgress: {
    width: '100%',
  },
}))

interface TableProps {
  title?: string | JSX.Element
  isValidating: boolean
  columns?: string[]
}

export const Table: React.FC<TableProps> = (props) => {
  const classes = useStyles()
  return (
    <Paper>
      {props.title && (
        <Toolbar>
          {(typeof props.title === 'string' && (
            <Typography variant='h6' component='div'>
              {props.title}
            </Typography>
          )) ||
            props.title}
        </Toolbar>
      )}
      <TableContainer>
        {props.isValidating && (
          <div className={classes.linearProgress}>
            <LinearProgress />
          </div>
        )}
        <MaterialTable>
          {props.columns && (
            <TableHead>
              <TableRow>
                {props.columns.map((column) => (
                  <TableCell key={column}>{column}</TableCell>
                ))}
              </TableRow>
            </TableHead>
          )}
          <TableBody>{props.children}</TableBody>
        </MaterialTable>
      </TableContainer>
    </Paper>
  )
}

export default Table
