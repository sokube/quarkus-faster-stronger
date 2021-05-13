SECONDS=0
for i in `seq 1 100`
do
  curl -N localhost:8092/reactive/randomflux/10000/1 &
done

wait
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." > test.log

SECONDS=0
# Launch 5 clients that will request the endpoint at the same time
for i in `seq 1 100`
do
  curl -N localhost:8080/reactive/randomflux/10000/1 &
done
wait
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> test.log
