using System;
using System.IO;
using System.Text;
using Microsoft.Deployment.WindowsInstaller;

namespace PoorMansTSqlFormatterSSMSPackage22.Setup.action
{
    public class SSMSPackageActions
    {
        const string SSMS22FILEKEY = "SSMS22FILE";

        [CustomAction]
        public static ActionResult PkgDefUpdateAction22(Session session)
        {
            return PkgDefUpdateAction(session, session.CustomActionData[SSMS22FILEKEY]);
        }

        private static ActionResult PkgDefUpdateAction(Session session, string pkgDefFilePath)
        {
            try
            {
                session.Log($"PkgDefUpdateAction: Processing {pkgDefFilePath}");

                if (!File.Exists(pkgDefFilePath))
                {
                    session.Log($"PkgDefUpdateAction: File not found: {pkgDefFilePath}");
                    return ActionResult.Failure;
                }

                string content = File.ReadAllText(pkgDefFilePath);
                string updatedContent = content.Replace("$RootFolder$", $"[$RootFolder$]\{Path.GetFileNameWithoutExtension(pkgDefFilePath)}");
                File.WriteAllText(pkgDefFilePath, updatedContent);

                session.Log($"PkgDefUpdateAction: Successfully updated {pkgDefFilePath}");
                return ActionResult.Success;
            }
            catch (Exception ex)
            {
                session.Log($"PkgDefUpdateAction: Error - {ex.Message}");
                return ActionResult.Failure;
            }
        }
    }
}
