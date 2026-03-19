using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

namespace PoorMansTSqlFormatterSSMSPackage22.Setup
{
    public class SetupInstaller
    {
        [STAThread]
        public static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            bool uninstall = args.Length > 0 && args[0].Equals("/uninstall", StringComparison.OrdinalIgnoreCase);
            using (var form = new SetupForm(uninstall))
            {
                Application.Run(form);
            }
        }
    }
}
    
    public class SetupForm : Form
    {
        private TextBox logTextBox;
        private Button installButton;
        private ProgressBar progressBar;
        private bool uninstall;

        public SetupForm(bool uninstall)
        {
            this.uninstall = uninstall;
            InitializeForm();
        }

        private void InitializeForm()
        {
            this.Text = uninstall ? "Uninstall Extension" : "Install Poor Man's T-SQL Formatter for SSMS 22";
            this.Size = new System.Drawing.Size(600, 400);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;

            var titleLabel = new Label
            {
                Text = "Poor Man's T-SQL Formatter for SSMS 22",
                Font = new System.Drawing.Font("Microsoft Sans Serif", 14F, System.Drawing.FontStyle.Bold),
                AutoSize = true,
                Location = new System.Drawing.Point(20, 20)
            };
            this.Controls.Add(titleLabel);

            logTextBox = new TextBox
            {
                Multiline = true,
                ReadOnly = true,
                ScrollBars = ScrollBars.Vertical,
                Location = new System.Drawing.Point(20, 90),
                Size = new System.Drawing.Size(540, 200),
                Font = new System.Drawing.Font("Consolas", 9F)
            };
            this.Controls.Add(logTextBox);

            progressBar = new ProgressBar
            {
                Location = new System.Drawing.Point(20, 300),
                Size = new System.Drawing.Size(540, 23),
                Style = ProgressBarStyle.Continuous
            };
            this.Controls.Add(progressBar);

            installButton = new Button
            {
                Text = uninstall ? "Uninstall" : "Install",
                Location = new System.Drawing.Point(475, 330),
                Size = new System.Drawing.Size(85, 30)
            };
            installButton.Click += InstallButton_Click;
            this.Controls.Add(installButton);

            var closeButton = new Button
            {
                Text = "Close",
                Location = new System.Drawing.Point(385, 330),
                Size = new System.Drawing.Size(85, 30)
            };
            closeButton.Click += (s, e) => this.Close();
            this.Controls.Add(closeButton);
        }

        private void InstallButton_Click(object sender, EventArgs e)
        {
            installButton.Enabled = false;
            progressBar.Style = ProgressBarStyle.Marquee;
            var bgWorker = new System.ComponentModel.BackgroundWorker();
            bgWorker.DoWork += (s, args) => {
                try {
                    if (uninstall) UninstallExtension();
                    else InstallExtension();
                    this.Invoke((Action)(() => {
                        progressBar.Style = ProgressBarStyle.Continuous;
                        progressBar.Value = 100;
                        Log(uninstall ? "Uninstall completed!" : "Install completed!");
                        MessageBox.Show(uninstall ? "Uninstall complete!" : "Install complete! Please restart SSMS 22.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }));
                } catch (Exception ex) {
                    this.Invoke((Action)(() => Log("Error: " + ex.Message)));
                }
            };
            bgWorker.RunWorkerAsync();
        }

        private void Log(string message)
        {
            if (logTextBox.InvokeRequired)
                logTextBox.Invoke((Action)(() => logTextBox.AppendText(message + "\r\n")));
            else
                logTextBox.AppendText(message + "\r\n");
        }

        private void InstallExtension()
        {
            string ssmsPath = @"C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions";
            string targetPath = Path.Combine(ssmsPath, "PoorMansTSqlFormatter");
            string sourcePath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

            Log("Checking SSMS 22 installation...");
            if (!Directory.Exists(ssmsPath))
                throw new Exception("SSMS 22 is not installed.");

            Log("Creating extension directory: " + targetPath);
            if (Directory.Exists(targetPath))
            {
                Log("Removing existing installation...");
                Directory.Delete(targetPath, true);
            }
            Directory.CreateDirectory(targetPath);

            Log("Copying files from: " + sourcePath);
            foreach (string file in Directory.GetFiles(sourcePath, "*.*", SearchOption.TopDirectoryOnly))
            {
                string fileName = Path.GetFileName(file);
                if (!fileName.EndsWith(".exe") && !fileName.EndsWith(".config") && !fileName.EndsWith(".install"))
                {
                    string destFile = Path.Combine(targetPath, fileName);
                    Log("  Copying: " + fileName);
                    File.Copy(file, destFile, true);
                }
            }

            Log("Registering uninstall information...");
            RegisterUninstall();
            Log("Triggering extension refresh...");
            TriggerExtensionRefresh(ssmsPath);
        }

        private void UninstallExtension()
        {
            string targetPath = @"C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions\PoorMansTSqlFormatter";
            string ssmsPath = @"C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Extensions";

            Log("Removing extension directory: " + targetPath);
            if (Directory.Exists(targetPath))
            {
                Directory.Delete(targetPath, true);
                Log("Extension files removed.");
            }
            else
            {
                Log("Extension not found.");
            }
            Log("Removing uninstall registration...");
            UnregisterUninstall();
            TriggerExtensionRefresh(ssmsPath);
        }

        private void RegisterUninstall()
        {
            string exePath = Assembly.GetExecutingAssembly().Location;
            string uninstallKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22";
            using (Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.LocalMachine.CreateSubKey(uninstallKey))
            {
                key.SetValue("DisplayName", "Poor Man's T-SQL Formatter for SSMS 22");
                key.SetValue("DisplayVersion", "2.2.0.0");
                key.SetValue("Publisher", "Poor Man's T-SQL Formatter");
                key.SetValue("UninstallString", "\"" + exePath + "\" /uninstall");
                key.SetValue("NoModify", 1);
                key.SetValue("NoRepair", 1);
            }
        }

        private void UnregisterUninstall()
        {
            Microsoft.Win32.Registry.LocalMachine.DeleteSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PoorMansTSqlFormatterSSMS22", false);
        }

        private void TriggerExtensionRefresh(string extensionsPath)
        {
            try
            {
                string triggerFile = Path.Combine(extensionsPath, "extensions.configurationchanged");
                File.WriteAllText(triggerFile, DateTime.Now.ToString());
                Log("Extension refresh triggered.");
            }
            catch (Exception ex)
            {
                Log("Warning: Could not trigger refresh: " + ex.Message);
            }
        }
    }
