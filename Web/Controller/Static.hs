module Web.Controller.Static where
import Web.Controller.Prelude
import Web.View.Static.Welcome
import Web.View.Static.GithubCommits
import IHP.RouterSupport
import qualified GitHub as Github
import Data.Vector ( toList )

getAllCommits :: Github.Request k (Vector Github.Commit)
getAllCommits = Github.commitsForR "r33drichards" "ihpp" Github.FetchAll
getCommits :: IO (Either Github.Error (Vector Github.Commit))
getCommits =  Github.executeRequest' getAllCommits

instance Controller StaticController where
    action GithubCommitsAction = do
        commits <-  getCommits
        case commits of
            Right commits -> do
                render GithubCommitsView { commits = Data.Vector.toList commits }
            Left err -> do
                putStrLn $ "Error getting commits: " <> tshow err
                setErrorMessage "Error getting commits"
                render GithubCommitsView { commits = [] }
