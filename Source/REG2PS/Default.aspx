<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs"
    Inherits="REG2PS.Default1" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <script type="text/javascript">
            function ShowMessage(message, messagetype) {
                var cssclass;
                switch (messagetype) {
                    case 'Success':
                        cssclass = 'alert-success'
                        break;
                    case 'Error':
                        cssclass = 'alert-danger'
                        break;
                    case 'Warning':
                        cssclass = 'alert-warning'
                        break;
                    default:
                        cssclass = 'alert-info'
                }
                $('#alert_container').append('<div id="alert_div" style="margin: 0 0.5%; -webkit-box-shadow: 3px 4px 6px #999;" class="alert fade in ' + cssclass + '"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><strong>' + messagetype + '!</strong> <span>' + message + '</span></div>');
            }
            function callAlert(msg) {
                alert(msg);
            }
            // based on https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop#process_the_drop
            function dropHandler(ev) {
                // Prevent default behavior (Prevent file from being opened)
                ev.preventDefault();

                let file;
                if (ev.dataTransfer.items) {
                    // Use DataTransferItemList interface to access the file
                    const item = ev.dataTransfer.items[0];
                    if (item.kind === "file") {
                        file = item.getAsFile();
                    }
                } else {
                    // Use DataTransfer interface to access the file(s)
                    file = ev.dataTransfer.files[0];
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementsByTagName("textarea")[0].value = e.target.result;
                };
                reader.readAsText(file);
            }
            function download() {
                const data = document.getElementsByTagName('textarea')[1].value;
                // TODO there must be a better way...
                const name = data.includes('New-Item') ? 'remediation.ps1' : 'detection.ps1';

                let link = document.createElement("a");
                link.download = name;
                link.href = "data:application/octet-stream," + escape(data);
                link.click();
            }
        </script>
        <div class="col-md-10 col-md-offset-1 container">
            <div class="row">
                <p>Create PowerShell scripts from Registry Editor exports (.reg files), ready to use with Intune <a
                        href="https://learn.microsoft.com/en-us/mem/intune/fundamentals/remediations">remediations</a>
                    or <a href="https://learn.microsoft.com/en-us/mem/intune/apps/intune-management-extension">platform
                        scripts</a>.</p>
            </div>
            <div class="row">
                <div class="col-md-12 form-group">
                    <label>Registry:</label>
                    <asp:TextBox ID="tb_REG" runat="server" class="form-control" required="required"
                        placeholder="Drag and drop your .reg file here, or paste its contents..." Rows="10"
                        TextMode="MultiLine" Font-Bold="False" ondrop="dropHandler(event);"></asp:TextBox>
                </div>
                <div class="col-md-12 form-group">
                    <label>PowerShell:</label>
                    <asp:TextBox ID="tb_PSSCript" runat="server" class="form-control"
                        placeholder="..and you will get the PowerShell code here..." Rows="10" TextMode="MultiLine"
                        BackColor="#012456" ForeColor="White" Font-Names="Helvetica" Font-Bold="False" ReadOnly="true">
                    </asp:TextBox>
                </div>
            </div>
            <br />
            <div>
                <asp:LinkButton ID="bt_Compile" runat="server" CssClass="btn btn-primary" OnClick="bt_Compile_Click">
                    <span aria-hidden="true" class="glyphicon glyphicon-send"></span> Get detection script
                </asp:LinkButton>
                <asp:LinkButton ID="bt_GetRemPS" runat="server" CssClass="btn btn-primary" OnClick="bt_GetRemPS_Click">
                    <span aria-hidden="true" class="glyphicon glyphicon-send"></span> Get remediation script
                </asp:LinkButton>
                <asp:LinkButton class="btn btn-success" onclick="download()">
                    <span aria-hidden="true" class="glyphicon glyphicon-send"></span> Download
                </asp:LinkButton>
            </div>
            <br />
            <div class="messagealert row" id="alert_container">
            </div>
        </div>
    </asp:Content>