CREATE TABLE [dbo].[_tb_dict_shift_per_production_line] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [ProducionLine]       VARCHAR (100) NOT NULL,
    [ShiftName]           VARCHAR (100) NOT NULL,
    [Begin]               TIME (7)      NOT NULL,
    [End]                 TIME (7)      NOT NULL,
    [PreviousDayAnchored] BIT           NOT NULL
);


GO

