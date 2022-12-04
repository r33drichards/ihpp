module Web.View.Static.GithubCommits where
import Web.View.Prelude

import qualified GitHub as Github

data GithubCommitsView = GithubCommitsView{ commits ::  [Github.Commit]}

renderCommit :: Github.Commit -> Html
renderCommit commit = [hsx|
    <div class="commit">
        <div class="commit-message">{Github.gitCommitMessage $ Github.commitGitCommit commit}</div>
    </div>
|]

instance View GithubCommitsView where
    html GithubCommitsView { .. } = [hsx|
        <h1>GithubCommitsView</h1>
        <p>Here are the latest commits from the GitHub API</p>
        <ul>
            {forEach commits renderCommit}
        </ul>
        |]
