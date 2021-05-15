for i in {1..15}
do
  SB_TO_KILL=$(kubectl get po --selector "app=sb-employee" --field-selector=status.phase=Running --output=name | head -n1)
  QK_NATIVE_TO_KILL=$(kubectl get po --selector "app=qk-native-employee" --field-selector=status.phase=Running --output=name | head -n1)
  QK_JVM_TO_KILL=$(kubectl get po --selector "app=qk-jvm-employee" --field-selector=status.phase=Running --output=name | head -n1)
#  SB_TO_KILL=$(kubectl get po --selector "app=sb-employee"  --output=name | head -n1)
#  QK_NATIVE_TO_KILL=$(kubectl get po --selector "app=qk-native-employee" --output=name | head -n1)
#  QK_JVM_TO_KILL=$(kubectl get po --selector "app=qk-jvm-employee" --field-selector=status.phase=Running --output=name | head -n1)

  echo "will kill $SB_TO_KILL - $QK_NATIVE_TO_KILL - $QK_JVM_TO_KILL"
  kubectl delete --force $SB_TO_KILL $QK_NATIVE_TO_KILL $QK_JVM_TO_KILL
  sleep 10
done

