class Match : public CObject
{
private:
    int start;
    int end;

public:
    Match(int startIndex = -1, int endIndex = -1) : start(startIndex), end(endIndex) {}
    void SetStart(int startIndex) { this.start = startIndex; }
    void SetEnd(int endIndex) { this.end = endIndex; }
    int GetStart() { return this.start; }
    int GetEnd() { return this.end; }
    bool IsEmpty() { return this.start == -1 && this.end == -1; }
};
