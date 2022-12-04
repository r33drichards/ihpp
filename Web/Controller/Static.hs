module Web.Controller.Static where
import Web.Controller.Prelude
import Web.View.Static.Welcome
import Web.View.Static.GithubCommits
import IHP.RouterSupport
import qualified GitHub as Github
import Data.Vector ( toList )
import qualified GitHub
import Data.Time.Clock (UTCTime, addUTCTime, getCurrentTime)
import Data.Time.Calendar (fromGregorian)
import GitHub (Owner)
import System.Environment (lookupEnv)


getAuth :: IO (Maybe (GitHub.Auth))
getAuth = do
    token <- lookupEnv "GITHUB_TOKEN"    
    pure (GitHub.OAuth . fromString <$> token)

yesterday :: IO UTCTime
yesterday = getCurrentTime >>= \time -> pure (addUTCTime (-86400 * 16) time)


getCommits :: Github.Name Github.Owner -> Github.Name Github.Repo -> IO (Either GitHub.Error (Vector GitHub.Commit))
getCommits owner repo = do
    auth <- getAuth
    time <- yesterday
    -- since yesterday
    GitHub.executeRequestMaybe auth $ Github.commitsWithOptionsForR 
        owner repo 20 [Github.CommitQuerySince time] 

instance Controller StaticController where
    action GithubCommitsAction = do
        commits <-  getCommits "brevdev" "brev-deploy"
        case commits of
            Right commits -> do
                render GithubCommitsView { commits = Data.Vector.toList commits }
            Left err -> do
                putStrLn $ "Error getting commits: " <> tshow err
                setErrorMessage "Error getting commits" 
                render GithubCommitsView { commits = [] }
