% Mesh plotting example

~~~~~~~~~~~~~~~~~~~~~~~~~~~{.matlab}
function plotmesh2d(mesh, opt)

~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Compatibility check

~~~~~~~~~~~~~~~~~~~~~~~~~~~{.matlab}
if exist('OCTAVE_VERSION')
  disp('Octave does not have sufficiently MATLAB-compatible graphics');
  return;
end

~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Option processing

This is a pattern I usually use for setting up defaults.


~~~~~~~~~~~~~~~~~~~~~~~~~~~{.matlab}
% -- This comment should not be typeset
anchors = optdefault(opt, 'anchors', 'g+');
forces  = optdefault(opt, 'forces',  'r+');
deform  = optdefault(opt, 'deform',   0  );
do_clf  = optdefault(opt, 'clf',      1  );
axequal = optdefault(opt, 'axequal',  0  );
xscale  = optdefault(opt, 'xscale',   1  );


~~~~~~~~~~~~~~~~~~~~~~~~~~~


