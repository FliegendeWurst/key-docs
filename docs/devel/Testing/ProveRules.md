# Regression tests for proved rules

#### Changes 

* Jan 2014, Mattias Ulbrich
* June 2015, Kai Wallisch

The taclet base for KeY grows constantly and it is difficult to
oversee that all these rules are sound. It is possible to prove
taclets sound within KeY. Such proofs may become invalidated by
changes in the taclet database.

We have implemented a test suite which reruns taclet proofs along with
the regression tests regularly and thereby ensures that these taclets
are sound in every (master) version of KeY.

ProveRules is a JUnit test suite that verifies correctness of taclets
by replaying their saved correctness proofs.

In order to add a taclet proof to ProveRules, the following steps are
necessary:

1. Annotate the taclet to be a lemma by adding "\lemma" in front of
   the taclet's name. For example, the declaration of taclet
   bsum_empty looks as follows:

      `\lemma bsum_empty { ... };`

2. Conduct a proof of the taclet by selecting the same taclet from
      `File -> Prove -> KeY's Taclets`.
   (Better to select one at a time).

3. Save a proof of the taclet in the folder

      `key/key.core.test/tacletProofs`

   or an arbitrary subfolder. It is recommended to use the name of the
   key-file in which the taclet has been defined as name of the
   subdirectory. The name of the proof file has to match the pattern:

      `Taclet_$TACLETNAME.proof`

   For example, the proof of the taclet bsum_empty can be found under

      `key/key.core.test/tacletProofs/bsum/Taclet_bsum_empty.proof`

The JUnit test case will fail

1. if there is a proof for a taclet that is not marked `\lemma`.
       (Just add the \lemma anntoation to the taclet) or 
2. if there is no proof for a taclet which is annotated lemma.
3. if there is a proof, but that cannot be replayed in KeY.


See class `de.uka.ilkd.key.proof.proverules.ProveRulesTest` for implementation
details.

In order to run taclet proofs manually, the following two options are available:

1. Use ProveRules command line interface, which is located at: `key/scripts/proveRules`
2. Execute ant task `proveRules` in component `key.core.test`.
