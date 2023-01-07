unit WatchAPI.UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TForm1 = class(TForm)
    StyleBook1: TStyleBook;
    LblPostANewJob: TLabel;
    Memo1: TMemo;
    LblGetJobByID: TLabel;
    EdtJobID: TEdit;
    BtnProcessNewJob: TButton;
    BtnGetReport: TButton;
    Memo2: TMemo;
    BtnGetJobs: TButton;
    EdtAPIAccKey: TEdit;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure BtnGetReportClick(Sender: TObject);
    procedure BtnProcessNewJobClick(Sender: TObject);
    procedure BtnGetJobsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.JSON, System.Threading;

procedure TForm1.BtnGetJobsClick(Sender: TObject);
begin
  var HTTP := TNetHTTPClient.Create(nil);
  try
    var Response := HTTP.Get('https://api.apilayer.com/404_watch/jobs&apikey='
                    + EdtAPIAccKey.Text);

    Memo2.Lines.Add(Response.ContentAsString);
  finally
    HTTP.Free;
  end;
end;

procedure TForm1.BtnGetReportClick(Sender: TObject);
begin
  var HTTP := TNetHTTPClient.Create(nil);
  try
    var Response := HTTP.Get('https://api.apilayer.com/404_watch/job/'
                    + EdtJobID.Text + '&apikey='
                    + EdtAPIAccKey.Text);

    Memo2.Lines.Add(Response.ContentAsString);
  finally
    HTTP.Free;
  end;
end;

procedure TForm1.BtnProcessNewJobClick(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      RESTClient1.ResetToDefaults;
      RESTClient1.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
      RESTClient1.AcceptCharset := 'utf-8, *;q=0.8';
      RESTClient1.BaseURL := 'https://api.apilayer.com/404_watch/job';
      RESTClient1.ContentType := 'application/json';

      RESTRequest1.ClearBody;
      RESTRequest1.Params.Clear;

      // API acc. key
      RESTRequest1.Params.AddItem;
      RESTRequest1.Params.Items[0].Kind := pkHTTPHEADER;
      RESTRequest1.Params.Items[0].Name := 'apikey';
      RESTRequest1.Params.Items[0].Value := EdtAPIAccKey.Text;
      RESTRequest1.Params.Items[0].Options := [poDoNotEncode];

      // set the url for checking
      RESTRequest1.Params.AddItem;
      RESTRequest1.Params.Items[1].Kind := pkREQUESTBODY;
      RESTRequest1.Params.Items[1].Name := 'body';
      RESTRequest1.Params.Items[1].Value := Memo1.Text; // sample body inserted
      RESTRequest1.Params.Items[1].ContentTypeStr := 'application/json';

      RESTRequest1.Execute;
    end);

  Memo2.Lines.Clear;
  Memo2.Lines.Add(RESTResponse1.Content);
end;

end.
