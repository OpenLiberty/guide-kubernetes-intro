# Contributing to Open Liberty guides

Anyone can contribute to the Open Liberty guides and we welcome your contributions!

There are multiple ways to contribute: report bugs, fix bugs, contribute code, improve upon documentation, etc.

## Raising issues

Please raise any bug reports in this [guide repository](../../issues). For new topics, large updates to existing guides, or general suggestions and ideas, report your issue in the [Open Liberty common guides repository](https://github.com/OpenLiberty/guides-common/issues). Be sure to search the list of open issues to see if your issue has already been raised.

A good bug report makes it easy for everyone to understand what you were trying to do and what went wrong. Provide as much context as possible so we can try to recreate the issue.

## Contributions

Contributing to an Open Liberty guide is simple. All you need to do is create your own branch to include your contribution and open a pull request to the `staging` (quality assurance) branch.

### Text or content contributions

If you are contributing text or content changes via a pull request, you need to certify that the originality of the work follows the [Developer Certificate of Origin (DCO)](https://developercertificate.org).

Add a line to the end of the Git commit message to sign your work:

```text
Signed-off-by: Jane Williams <jane.williams@gmail.com>
```

The sign-off is just a line at the end of the commit message that certifies that you wrote it or otherwise have the right to pass it on as an open source patch.

Use your real name when you sign. We can't accept pseudonyms or anonymous contributions.

Many Git UI tools have support for adding the `Signed-off-by` line to the end of your commit message. This line can be automatically added by the `git commit` command by using the `-s` option.

If reviewers agree with your change, your change will be merged to the `master` branch for publishing.

### Code contributions

If you are contributing trivial code changes such as typos, redundant spaces, or minor formatting and spelling errors, follow the instructions under [Text or content contributions](./CONTRIBUTING.md#text-or-content-contributions).

If you are contributing code changes via a pull request for non-trivial changes, you must sign off on the [Individual Contributor License Agreement](https://github.com/OpenLiberty/open-liberty/blob/master/cla/open-liberty-cla-individual.pdf). An example of a non-trivial change could be adding a new
microservice to the backend application of the guide.

If you are contributing changes as part of your job, you may also wish to have your employer sign a [Corporate Contributor License Agreement](https://github.com/OpenLiberty/open-liberty/blob/master/cla/open-liberty-cla-corporate.pdf).

Instructions for how to sign and submit these agreements are located at the top of each document.

After we obtain the signed CLA, you are welcome to open a pull request against the `staging` branch, and the team will be notified for review. We ask you follow these steps through the submission process:

1. Open a pull request against the `staging` branch.
2. A "CLA signed" label will be manually added by the team.
3. The team will be notified and will review your change(s).
    - If there are further changes to be made, the team will request changes on the pull request.
    - If the team does not agree with the change, the PR will be closed with an explanation and suggestion for follow-up.
4. If the team approves, a full Open Liberty site build will be run.
5. Based on the results of the build:
    - If further review is needed, we will let you know about a pending review from our team and discuss any necessary improvements that need to be made to your change(s).
    - If everything is successful, the team will merge your PR.

## Questions and concerns

If you have any questions or concerns about the guides or about Open Liberty, you can visit [Gitter for Open Liberty](https://gitter.im/OpenLiberty/) and post your questions in the relevant rooms. You can also join the Open Liberty group on [Groups.io](https://groups.io/g/openliberty) to discuss any issues you have.
