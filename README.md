CandyCoin integration/staging tree
==================================

Copyright (c) 2009-2013 Bitcoin Developers
Copyright (c) 2013-2014 CandyCoin Developers

What is CandyCoin?
------------------

CandyCoin is anonymous internet currency. Payments are quickly processed
using a public peer-to-peer network operated by volunteers.

 * 60 second transaction times
 * 10 coins issued for each found block, halving approx every 1,051,200 blocks (~2 years)
 * approx 20.3 million coins will be issued
 * coin generation halts after 5,256,000 blocks (~10 years)
 * Kimoto Gravity Well with Timewarp patch after 100,000 blocks 
 
License
-------

CandyCoin is released under the terms of the MIT license. See `COPYING` for more
information or see http://opensource.org/licenses/MIT.

Development process
-------------------

Developers work in their own trees, then submit pull requests when they think
their feature or bug fix is ready.

If it is a simple/trivial/non-controversial change, then one of the CandyCoin
development team members simply pulls it.

If it is a *more complicated or potentially controversial* change, then the patch
submitter will be asked to start a discussion (if they haven't already) on the
[mailing list]

The patch will be accepted if there is broad consensus that it is a good thing.
Developers should expect to rework and resubmit patches if the code doesn't
match the project's coding conventions (see `doc/coding.txt`) or are
controversial.

The `master` branch is regularly built and tested, but is not guaranteed to be
completely stable. [Tags](https://github.com/eatsweetmoney/candycoin-official/tags) are created
regularly to indicate new official, stable release versions of CandyCoin.

Testing
-------

Testing and code review is the bottleneck for development; we get more pull
requests than we can review and test. Please be patient and help out, and
remember this is a security-critical project where any mistake might cost people
lots of money.

### Automated Testing

Developers are strongly encouraged to write unit tests for new code, and to
submit new unit tests for old code.

Unit tests for the core code are in `src/test/`. To compile and run them:

    cd src; make -f makefile.unix test

Unit tests for the GUI code are in `src/qt/test/`. To compile and run them:

    qmake BITCOIN_QT_TEST=1 -o Makefile.test candycoin-qt.pro
    make -f Makefile.test
    ./candycoin-qt_test

