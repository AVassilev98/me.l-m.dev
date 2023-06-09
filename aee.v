import db.sqlite
import time

[table: 'posts']
struct Post {
	id int [primary; sql: serial]
	created_at time.Time
	tags string // space separated
mut:
	content string
}

fn raw_query(db &sqlite.DB, query string) ![]sqlite.Row {
	rows, ret := db.exec(query)

	if sqlite.is_error(ret) {
		return db.error_message(ret, query)
	}

	return rows
}

fn main() {
	mut db := sqlite.connect('data.sqlite')!
	defer { db.close() or {} }

	// row, ret := db.exec('select * from posts where content glob "*wasm*"')

	row := raw_query(db, "select * from posts 
		where (content glob '**')
		and (tags like '%3d%' or tags like '%threejs%' or tags like '%cs%');")!

	println(row.first())
}