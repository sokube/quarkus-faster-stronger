SECONDS=0
for i in `seq 1 100`
do
  curl -N localhost:53126/reactive/randomflux/1000/1 &
done

wait
duration=$SECONDS
echo "QUARKUS-JVM: $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." > test.log


SECONDS=0
for i in `seq 1 100`
do
  curl -N localhost:53245/reactive/randomflux/1000/1 &
done

wait
duration=$SECONDS
echo "SPRING-BOOT: $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> test.log

SECONDS=0
for i in `seq 1 100`
do
  curl -N localhost:53186/reactive/randomflux/1000/1 &
done

wait
duration=$SECONDS
echo "QUARKUS-NATIVE: $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> test.log
