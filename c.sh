git add figures/*
comment="$@"
if [ "$comment" == "" ]; then
    comment="no comment"
fi;
echo $comment
git commit -a -m "$comment"  && git push

