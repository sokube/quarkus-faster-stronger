SECONDS=0
for i in `seq 1 500`
do
  curl -N http://172.17.0.4:31450/reactive/randomflux/1000/50 &
done

wait
duration=$SECONDS
echo "QUARKUS-JVM: $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." > test.log


SECONDS=0
for i in `seq 1 500`
do
  curl -N http://172.17.0.4:32318/reactive/randomflux/1000/50 &
done

wait
duration=$SECONDS
echo "SPRING-BOOT: $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> test.log

SECONDS=0
for i in `seq 1 500`
do
  curl -N http://172.17.0.4:31524/reactive/randomflux/1000/50 &
done

wait
duration=$SECONDS
echo "QUARKUS-NATIVE: $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> test.log
