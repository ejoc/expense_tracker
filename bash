(for f in `find spec -iname '*_spec.rb'`; do                              ↩​
​ 	​    echo "$f:"                                                              ↩​
​ 	​    bundle exec rspec $f -fp || exit 1                                      ↩​
​ 	​  done)​