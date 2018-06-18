
if ! tmux has-session -t yancy; then
	tmux new -s yancy -d
	tmux new-window -t yancy:2
	tmux split-window -t yancy:2 -v
	tmux send-keys -t yancy:1 vim Enter
	tmux send-keys -t yancy:2.0 'cd perl/Yancy; morbo bin/yancy' Enter
	tmux send-keys -t yancy:2.1 'export TEST_YANCY_EXAMPLES=1' Enter
	tmux new-window -t yancy:3 postgres -D ~/perl/Yancy/db/pg
	tmux split-window -t yancy:3 mysqld --skip-grant-tables \
	    --datadir ~/perl/Yancy/db
fi

tmux attach -t yancy

